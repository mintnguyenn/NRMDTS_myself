#include "ros/ros.h"

#include "ur5e_kinematics.h"

int main(int argc, char **argv)
{
  ros::init(argc, argv, "testing");

  ros::NodeHandle nh;

  double joint_space[6] = {0.16113, 5.8513, 1.89915, 1.67434, 1.40967, 3.14159};
  // const double joint_space[6] = {0, -M_PI/2, 0, -M_PI/2, 0, 0};
  double *q;
  q = &joint_space[0];

  double all_ikine[8][6];
  double *all_ik;
  all_ik = &all_ikine[0][0];

  double task_space[16] = {-1, 0, 0, 0.3, 0, 1, 0, 0.2, 0, 0, -1, 0.05, 0, 0, 0, 1};
  double *T = &task_space[0];

  // int a = ur5e_kinematics::inverse(T, all_ik);
  // for (unsigned int i = 0; i < 8; i++)
  // {
  //   for (unsigned int j = 0; j < 6; j++)
  //   {
  //     std::cout << all_ikine[i][j] << ", ";
  //   }
  //   std::cout << std::endl;
  // }

  ur5e_kinematics::forward(q, T);
  for (unsigned int i = 0; i < 16; i++)
  {
    std::cout << task_space[i] << "; " << std::endl;
  }

  ros::spin();

  /**
   * Let's cleanup everything, shutdown ros and join the thread
   */
  ros::shutdown();

  return 0;
}