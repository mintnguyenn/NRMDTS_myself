#include "ros/ros.h"

#include "ur5e_kinematics.h"


int main(int argc, char **argv)
{
  ros::init(argc, argv, "tntp_implementation");

  ros::NodeHandle nh;
  const unsigned int index = 7;

  // ur_kinematics::forward();

  ros::spin();

  /**
   * Let's cleanup everything, shutdown ros and join the thread
   */
  ros::shutdown();

  return 0;
}