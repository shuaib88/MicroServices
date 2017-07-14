from sh import kubectl
import time

def is_pod_running(name):
  return is_running('pod', name)

def is_svc_running(name):
  return is_running('service', name)

def is_running(ktype, name):
  try:
    output = kubectl.get([ktype, name])
    return True
  except Exception,err:
    #TODO: Need to check error and parse no pod found
    return False

def shutdown_pod(name, is_block=True):
  if is_pod_running(name):
    kubectl.delete.pod(name)
  else:
    print('%s does not exist' % name)
    return
  while is_block:
    if not is_pod_running(name):
      break
    else:
      print('Waiting for %s to terminate' % name)
      time.sleep(10)
  print('%s terminated' % name)
     

def shutdown_svc(name, is_block=True):
  if is_svc_running(name):
    kubectl.delete.service(name)
  else:
    print('%s does not exist' % name)
    return
  while is_block:
    if not is_svc_running(name):
      break
    else:
      print('Waiting for %s to terminate' % name)
      time.sleep(10)
  print('%s terminated' % name)
      
