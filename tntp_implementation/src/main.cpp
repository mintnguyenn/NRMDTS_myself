#include <ros/ros.h>

#include "ur5e_kinematics.h"
#include "ur5e_controller.h"

int main(int argc, char **argv)
{
  ros::init(argc, argv, "testing");

  ros::NodeHandle nh;

  std::shared_ptr<Manipulator_Controller> controller(new Manipulator_Controller());

  std::vector<double> start{0, -M_PI/2, 0, -M_PI/2, 0, 0};
  // std::vector<double> end{-M_PI/4, -M_PI/3, M_PI/2, 0, 0, 0};
  std::vector<double> end{  -1.9555,   -1.9831,   -1.8569,   -2.4432,    0.6625,    3.1416};
  // std::vector<double> end{  -0.3007 ,  -1.0472,    1.6768,    0. 9411,    1.5708,    2.8409};
  

  // controller->trajectoryBetween2Points(start, end);
  std::vector<std::vector<double>> array;
  controller->trajectoryFromArray(array);

  ros::spin();

  /**
   * Let's cleanup everything, shutdown ros and join the thread
   */
  ros::shutdown();

  return 0;
}
