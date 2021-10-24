#!/bin/sh
while true
do
  sleep 5
    cmd=`kubectl get pod -n staging -l app=rails-app 2>/dev/null | grep -i running | wc -l`
    if [ $cmd -eq '3' ];
    then
        echo "All pods are RUNNING now."
        break
    else
        echo "Waiting for all the pods to be created ..."
    fi
done

