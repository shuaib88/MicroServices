import argparse 
from kubernetes.helpers import shutdown_pod
from kubernetes.helpers import shutdown_svc
from sh import kubectl

def parse_args():
  parser = argparse.ArgumentParser(description="Ssdb restart",\
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)

  parser.add_argument('-p', '--pod_name', type=str, default='localhost',\
    help='SSDB store', required=True, choices=['ssdb-feed', 'ssdb-post'])

  args = parser.parse_args() 
  return args.pod_name

def main():
  args = parse_args()
  if not args:
    return
  pod_name = args

  shutdown_pod(pod_name + '-pod')
  shutdown_svc(pod_name + '-svc')
  pod_name = pod_name.replace('-','_')
  kubectl.create(['-f', '%s_pod.yaml' % pod_name])
  kubectl.create(['-f', '%s_svc.yaml' % pod_name])

if __name__ == '__main__':
  main()

