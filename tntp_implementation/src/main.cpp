#include <ros/ros.h>
#include <time.h>

#include "ur5e_kinematics.h"
#include "ur5e_controller.h"
#include "prmstar.h"
#include "input_data.h"
#include "environmental_obstacles.h"
#include "definitions.h"
#include "asymp_tntp_algorithm.h"

#include <moveit/move_group_interface/move_group_interface.h>
#include <moveit_visual_tools/moveit_visual_tools.h>
#include <moveit/planning_scene/planning_scene.h>
#include <geometry_msgs/Pose.h>

#include <moveit/ompl_interface/ompl_interface.h>
#include <ompl/geometric/SimpleSetup.h>
#include <ompl/geometric/planners/prm/PRM.h>
#include <ompl/geometric/planners/prm/PRMstar.h>
#include <ompl/base/spaces/RealVectorStateSpace.h>
#include <moveit/kinematic_constraints/utils.h>
#include <ompl/base/State.h>
#include <ompl/geometric/PathGeometric.h>

bool isStateValid(const std::vector<double> *joint_angles,
                  const planning_scene::PlanningScenePtr my_scene,
                  const moveit::core::JointModelGroup *joint_model_group)
{
  moveit::core::RobotState &current_state = my_scene->getCurrentStateNonConst();

  collision_detection::CollisionRequest req;

  collision_detection::CollisionResult res;
  res.clear();

  current_state.setJointGroupPositions(joint_model_group, *joint_angles);

  my_scene->checkCollision(req, res);

  return !res.collision;
}

int main(int argc, char **argv)
{
  const double joint_speed_velocity = 0.5;

  ros::init(argc, argv, "ur5e_optimal_tntp_planner");

  ros::NodeHandle nh;

  const std::string PLANNING_GROUP = "manipulator";

  // YT: we construct basic structures
  robot_model_loader::RobotModelLoader robot_model_loader("robot_description");
  const moveit::core::RobotModelPtr &kinematic_model = robot_model_loader.getModel();
  planning_scene::PlanningScenePtr planning_scene(new planning_scene::PlanningScene(kinematic_model));

  std::cout << "YT: We create basic scene structures" << std::endl;

  moveit::planning_interface::PlanningSceneInterface planning_scene_interface_;
  moveit::planning_interface::MoveGroupInterface ur5e_("manipulator");
  // std::cout << ur5e_.getCurrentPose() << std::endl;

  addObstacles_case_study_1(planning_scene_interface_, ur5e_);

  std::cout << "We print the name of all environmental obstacles. " << std::endl;
  int count = 0;
  std::map<std::string, moveit_msgs::CollisionObject> objects_in_environment = planning_scene_interface_.getObjects();
  for (auto iter = objects_in_environment.begin(); iter != objects_in_environment.end(); ++iter)
    std::cout << "Object " << count++ << " : " << iter->second.id << std::endl;

  std::cout << "YT: We add the objects into the planning scene. " << std::endl;
  for (auto iter = objects_in_environment.begin(); iter != objects_in_environment.end(); ++iter)
    planning_scene->processCollisionObjectMsg(iter->second);

  moveit::core::RobotState &current_state = planning_scene->getCurrentStateNonConst();
  const moveit::core::JointModelGroup *joint_model_group = current_state.getJointModelGroup(PLANNING_GROUP);

  ros::Duration(5.0).sleep(); // We wait all modules to be loaded. Then we calculate time

  ///////////////////////////////////////////////////WE SETUP OUR PRMSTAR////////////////////////////////////
  std::function<bool(const std::vector<double> *)> collisionChecker =
      std::bind(&isStateValid, std::placeholders::_1, planning_scene, joint_model_group);

  srand(0);
  optimal_tntp::PRMstar our_prmstar(collisionChecker);

  ros::WallTime initial_guess_time_start = ros::WallTime::now();
  for (unsigned int i = 0; i < 500; ++i)
    our_prmstar.add_milestone();

  our_prmstar.showDetails();

  /////////////////////////////////////////// TESTING PRM STAR ALGORITHM //////////////////////////////////////////

  std::vector<double> def{0, -M_PI / 2, 0, -M_PI / 2, 0, 0};
  std::vector<double> start{0, -M_PI, 0, -M_PI / 2, 0, 0};

  optimal_tntp::RobotState source(def);
  optimal_tntp::RobotState target(start);
  std::vector<optimal_tntp::RobotState> result;
  result.clear();

  our_prmstar.findPath(source, target, result);
  std::vector<std::vector<double>> joint_result;
  for (unsigned int j = 0; j < result.size(); j++)
  {
    joint_result.push_back(result.at(j).joint_);
  }

  controller::linearInterpolateConfigurationss(joint_result);

  std::shared_ptr<Manipulator_Controller> controller(new Manipulator_Controller());
  controller->trajectoryFromArray(joint_result);

  //////////////////////////////////////////////////// THE PRE-DEFINED TASK-SPACE CURVE///////////////////////////
  std::cout << "YT: we define the task-space curve. " << std::endl;

  // std::string file_name = "/home/yangtong/prm_ws/src/tntp_implementation/data/case_study_1";
  std::string file_name;
  nh.getParam("/asympTNTP/task_space_motion", file_name);

  std::string input_file_name = file_name + ".txt";

  std::vector<TaskSpaceWaypoint> TSpoints;
  TSpoints = case_study_1_matrix44(input_file_name);

  // std::cout << "YT: We do collision checking for all the IKs" << std::endl;
  collision_detection::CollisionRequest collision_request;
  collision_detection::CollisionResult collision_result;
  for(auto iter = TSpoints.begin(); iter != TSpoints.end(); ++iter)
  {
  	int i = 0;
  	while(i < iter->iks_.size()){
  		std::vector<double> temp = iter->iks_[i];
  			current_state.setJointGroupPositions(joint_model_group, temp);

  		collision_result.clear();
  		planning_scene->checkCollision(collision_request, collision_result);

  		if(collision_result.collision)
  			iter->iks_.erase(iter->iks_.begin()+i);

  		else
  			++i;
  	}
  	// std::cout << "Task-space point " << iter-TSpoints.begin() << " has " << iter->iks_.size() << " valid IKs" << std::endl;
  }

  /////////////////////////////////////////WE CREATE CONTINUOUS TRACKING MOTIONS//////////////////////////////////
	std::vector<ContinuousTrackingMotion> CTM;

	double epsilon_cont = 0.1;
	optimal_tntp_algorithm::defineStates(TSpoints, epsilon_cont, CTM);
	// Note that here the continuous sets do not have an index

	// We create the home configuration as the first continuous set, and adjust all data structures
	ContinuousTrackingMotion CTM0;
	CTM0.color_ = 0;
	CTM0.first_point_index_ = 0;
	CTM0.last_point_index_ = 0;
	CTM.insert(CTM.begin(), CTM0);
	for (auto iter = CTM.begin() + 1; iter != CTM.end(); ++iter)
	{
		iter->color_ = iter - CTM.begin();
		iter->first_point_index_++;
		iter->last_point_index_++;
	}

	std::cout << "We check all CTMs: " << std::endl;
	for(auto iter = CTM.begin(); iter != CTM.end(); ++iter)
	{
		std::cout << "[color, first_point_index, last_point_index] = [" << iter->color_ << ", " << iter->first_point_index_ << ", " << iter->last_point_index_ << "]" << std::endl;
	}

	for(auto iter = TSpoints.begin(); iter != TSpoints.end(); ++iter)
	{
		for(auto iter2 = iter->color_.begin(); iter2 != iter->color_.end(); ++iter2)
		{
			++*iter2;
		}
	}






  ros::spin();

  /**
   * Let's cleanup everything, shutdown ros and join the thread
   */
  ros::shutdown();

  return 0;
}
