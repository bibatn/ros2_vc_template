#include <memory>
#include <stdio.h>
#include "rclcpp/rclcpp.hpp"
#include "[name]/ros_[name].h"

int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  rclcpp::NodeOptions node_options;
//  node_options.append_parameter_override("paramsYml", argv[1]); //Uncoment to launch only with command line
  rclcpp::spin(std::make_shared<ros_vc::[Name]Node>(node_options));
  rclcpp::shutdown();
  return 0;
}
