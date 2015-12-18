#!/bin/bash

# Create the common REPLICATION string to be used when creating Clearwater
# Cassandra schemas. This file gets dotted in by the schema creation scripts.
replication_str="{'class': 'SimpleStrategy', 'replication_factor': 2}"

# If local_site_name and remote_site_names are set then this is a GR
# deployment. Set the replication strategy to NetworkTopologyStrategy and
# define the sites.
if [ -n $local_site_name ] && [ -n $remote_site_names ]
then
  IFS=',' read -a remote_site_names_array <<< "$remote_site_names"
  replication_str="{'class': 'NetworkTopologyStrategy', '$local_site_name': 2"
  for remote_site in "${remote_site_names_array[@]}"
  do
    # Set the replication factor for each site to 2.
    replication_str+=", '$remote_site': 2"
  done
  replication_str+="}"
fi
