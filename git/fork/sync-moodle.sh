syncroot=/c/@/sync

for fork in `ls $syncroot`
do
  sync-fork.sh $syncroot/$fork
done