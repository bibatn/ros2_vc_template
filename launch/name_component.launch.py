import launch
from launch_ros.actions import ComposableNodeContainer
from launch_ros.descriptions import ComposableNode


def generate_launch_description():
    """Generate launch description with multiple components."""
    container = ComposableNodeContainer(
            node_name='my_container',
            node_namespace='',
            package='rclcpp_components',
            node_executable='component_container',
            composable_node_descriptions=[
                ComposableNode(
                    package='[name]',
                    node_plugin='ros_vc::[Name]Node',
                    parameters=[{"paramsYml": "/home/NAMI/marat.habibulin/projects/VisualCortex/bin/res/struct/struct_outvideo.yml"}],
                    node_name='[name]')
            ],
            output='screen'
    )

    return launch.LaunchDescription([container])
