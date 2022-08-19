import launch
from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='[name]',
            node_executable='[name]_node',
            output='screen',
            parameters=[{"paramsYml": "/home/NAMI/marat.habibulin/projects/VisualCortex/bin/res/struct/struct_outvideo.yml"}]
        ),
    ])
