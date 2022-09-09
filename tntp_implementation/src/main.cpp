#include <ros/ros.h>

#include "ur5e_kinematics.h"
#include "ur5e_controller.h"

int main(int argc, char **argv)
{
  ros::init(argc, argv, "testing");

  ros::NodeHandle nh;

  

  std::shared_ptr<Manipulator_Controller> controller(new Manipulator_Controller());
  control_msgs::FollowJointTrajectoryGoal goal;

  std::vector<double> start{0, -M_PI/2, 0, -M_PI/2, 0, 0};
  std::vector<double> end{-M_PI/4, -M_PI/3, M_PI/2, 0, 0, 0};

  goal.trajectory = controller->generateTrajectoryBetween2Points(start, end);
  controller->goal_.trajectory = controller->generateTrajectoryBetween2Points(start, end);

  // for (auto e : controller->goal_.trajectory.points.at(1).positions)
  //   std::cout << e << std::endl;
  // end;
  controller->client_->sendGoal(controller->goal_);
  ros::spin();

  /**
   * Let's cleanup everything, shutdown ros and join the thread
   */
  ros::shutdown();

  return 0;
}
