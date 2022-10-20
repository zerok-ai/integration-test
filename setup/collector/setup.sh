#! /bin/bash

# showHelp()
# {
#     echo "Usage: "
#     echo "      ./setup.sh         :does the setup"
#     echo "      ./setup.sh apply   :does the setup"
#     echo "      ./setup.sh delete  :deletes the setup"
# }



# if [ "$setup_mode" = 'default' -o "$setup_mode" = 'anton' -o "$setup_mode" = 'clean' ]; then
#     echo "Setting up cluster for ${setup_mode}"
# else
#     showHelp()
#     exit 0
# fi


if [ "$1" = "delete" ]; then

    echo "# ==============================="
    echo "Deleting setup"
    echo "# -------------------------------"

    kubectl delete -k default-setup
    kubectl delete namespace isolation-anton 
    
else

    echo "# ==============================="
    echo "Setup initialized"
    kubectl apply -k default-setup

    echo "Setting data collection pod"
    sh configure-deployment.sh

    echo "Set the ip in Endpoint object"
    sh configure-ip.sh

fi