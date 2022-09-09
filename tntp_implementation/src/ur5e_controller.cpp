#include "ur5e_controller.h"

trajectory_msgs::JointTrajectoryPoint initialiseTrajectoryPoint(const std::vector<double> joint_space, double duration)
{
    trajectory_msgs::JointTrajectoryPoint points;

    points.positions.resize(6);
    points.velocities.resize(6);
    points.accelerations.resize(6);
    for (unsigned int i = 0; i < 6; i++)
    {
        points.positions[i] = joint_space.at(i);
        points.velocities[i] = 0.0;
        points.accelerations[i] = 0.0;
    }

    points.time_from_start = ros::Duration(duration);

    return points;
}

Manipulator_Controller::Manipulator_Controller()
{
    // actionlib::SimpleActionClient<control_msgs::FollowJointTrajectoryAction> robot_client("/scaled_pos_joint_traj_controller/follow_joint_trajectory", true);
    client_ = new Client("/scaled_pos_joint_traj_controller/follow_joint_trajectory", true);

    ROS_INFO("Waiting for action server to start.");

    // wait for the action server to start
    client_->waitForServer(); // will wait for infinite time

    ROS_INFO("Action server started, sending goal.");
}

Manipulator_Controller::~Manipulator_Controller(){

}

trajectory_msgs::JointTrajectory Manipulator_Controller::generateTrajectoryBetween2Points(std::vector<double> start_point, std::vector<double> end_point)
{
    //
    trajectory_msgs::JointTrajectory goal_trajectory;

    //
    goal_trajectory.header.stamp = ros::Time::now() + ros::Duration(2);

    // Initialise joint names
    goal_trajectory.joint_names.resize(6);
    goal_trajectory.joint_names[0] = "shoulder_pan_joint";
    goal_trajectory.joint_names[1] = "shoulder_lift_joint";
    goal_trajectory.joint_names[2] = "elbow_joint";
    goal_trajectory.joint_names[3] = "wrist_1_joint";
    goal_trajectory.joint_names[4] = "wrist_2_joint";
    goal_trajectory.joint_names[5] = "wrist_3_joint";

    goal_trajectory.points.resize(2);
    goal_trajectory.points.at(0) = initialiseTrajectoryPoint(start_point, 4.0);
    goal_trajectory.points.at(1) = initialiseTrajectoryPoint(end_point, 8.0);

    return goal_trajectory;
}
