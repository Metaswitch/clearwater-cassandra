. /etc/clearwater/config
# Note that although this doesn't use any config settings, it's
# structured like this for consistency with other files and future extensibility.
cat << EOF
# A simple configuration file for monitoring the local host
# This can serve as an example for configuring other servers;
# Custom services specific to this host are added here, but services
# defined in icinga-common_services.cfg may also apply.
#

define command{
        command_name    restart-cassandra
        command_line    /usr/share/clearwater/icinga/clearwater_event_handler \$SERVICESTATE$ \$SERVICESTATETYPE$ \$SERVICEATTEMPT$ /var/run/cassandra.pid 600
        }

define service{
        use                             cw-service         ; Name of service template to use
        host_name                       localhost
        service_description             Cassandra port open
	check_command                   check_tcp_port!9160
        event_handler                   restart-cassandra
        }

define service{
        use                             cw-service         ; Name of service template to use
        host_name                       localhost
        service_description             Cassandra CPU below 90pc
	check_command                   check_cassandra_cpu!90
        event_handler                   restart-cassandra
        }

EOF
