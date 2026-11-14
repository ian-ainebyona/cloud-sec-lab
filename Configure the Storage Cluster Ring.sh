# Extract the auto-generated Node ID
NODE_ID=$(docker exec -it block1-garage ./garage status | awk 'NR==3 {print $1}')

# Assign the node to datacenter zone dc1 with 10GB allocation
docker exec -it block1-garage ./garage layout assign -z dc1 -c 10G $NODE_ID

# Apply the cluster layout version
docker exec -it block1-garage ./garage layout apply --version 1

# Create your audit logs bucket and API access key
docker exec -it block1-garage ./garage bucket create scc-audit-logs
docker exec -it block1-garage ./garage key create scanner-key
docker exec -it block1-garage ./garage bucket allow --read --write --owner scc-audit-logs --key scanner-key