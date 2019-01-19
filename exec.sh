docker exec -it --privileged=true `docker ps | grep dotnet2.2_perf | awk '{print $1}'` /perfcollect install
docker exec --privileged=true `docker ps | grep dotnet2.2_perf | awk '{print $1}'` /bin/bash
