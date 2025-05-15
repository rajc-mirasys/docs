#!/bin/bash -i
source /home/mirasys/.bashrc

# Input parameter with hyphens
INPUT="$1"

IFS='-' read -ra PARAMS <<< "$INPUT"
echo ${PARAMS[0]}
echo ${PARAMS[1]}

if [[ "$input" =~ ^[+-]?[0-9]+$ ]]; then
  APP_ID=$(printf "app_%02d" "${PARAMS[0]}")
  APP_ID="${APP_ID,,}"
  echo "Input is an integer." "$APP_ID"
else
  APP_ID=${PARAMS[0]}
  APP_ID="${APP_ID,,}"
  echo "Input is not an integer." "$APP_ID"
fi

GPU_ID=${PARAMS[1]}

log_dir=/var/log/mirasys/$APP_ID/console
mkdir -p $log_dir
log=c_$(date +%Y-%m-%d).log

echo $APP_ID
echo $GPU_ID
echo $log_dir
export CUDA_VISIBLE_DEVICES=$GPU_ID
export FFREPORT=level=quiet
export OPENBLAS_NUM_THREADS=2
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
#export OPENCV_FFMPEG_CAPTURE_OPTIONS='rtsp_transport;udp|rtbufsize;500M|buffer_size;200000|allowed_media_types;video'
export OPENCV_FFMPEG_CAPTURE_OPTIONS='rtsp_transport;udp|rtbufsize;50M|buffer_size;0|allowed_media_types;video'
export OPENCV_FFMPEG_CAPTURE_OPTIONS='rtsp_transport;tcp'

cd /usr/local/mirasys
source /home/mirasys/.venv-3.13/bin/activate
./MirasysAI.rnix -u http://mirasys_api_tenant_gateway.local -i $APP_ID >> $log_dir/$log 2>&1

# ./MirasysAI.rnix --config configs/$APP_ID.json >> $log_dir/$log 2>&1e
# numactl --cpunodebind=$GPU_ID --membind=$GPU_ID ./MirasysAI.rnix --config configs/$APP_ID.json >> $log_dir/$log 2>&1