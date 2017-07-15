from proto.feed_pb2 import InterDayData
from proto.feed_pb2 import OptionMeta
from proto.feed_pb2 import IntraDayData
from proto.feed_pb2 import OptionChains
from proto.post_process_pb2 import PairedData
from proto.dividend_pb2 import DividendData

class MultiKey:
  """MultiKey is an abstract class"""

  def __str__(self):
    return self.key

  def GetKeys(self, ssdb_client):
    n = 0
    while ssdb_client.exists('%s_%d' % (self.key, n)):
      yield '%s_%d' % (self.key, n)
      n += 1

  def GetInstances(self, ssdb_client):
    for key in self.GetKeys(ssdb_client):
      val = ssdb_client.get(key)
      if val:
        instance = self.instance_type()
        instance.ParseFromString(val)
        yield instance

  def SetInstances(self, ssdb_client, instances):
    i = 0
    for instance in instances:
      key = '%s_%d' % (self.key, n)
      ssdb_client.set(key, instance.SerializeToString())
      i += 1

  def DeleteInstances(self, ssdb_client):
    for key in self.GetInstances(ssdb_client):
      ssdb_client.delete(key)

class SingleKey:
  """SingleKey is an abstract class"""

  def __str__(self):
    return self.key

  def DoesKeyExist(self, ssdb_client):
    if ssdb_client.exists(self.key):
      return self.key

  def GetInstance(self, ssdb_client):
    val = ssdb_client.get(self.key)
    if val:
      instance = self.instance_type()
      instance.ParseFromString(val)
      return instance     

  def SetInstance(self, ssdb_client, instance):
    ssdb_client.set(self.key, instance.SerializeToString()) 

  def DeleteInstance(self, ssdb_client):
    ssdb_client.delete(self.key)

#class IntraKey(SingleKey):
#  def __init__(self, symbol, date):
#    self.key = '%s_intra_%s' % (symbol, date)
#    self.instance_type = IntraDayData

class IntraKey(MultiKey):
  def __init__(self, symbol, date):
    self.key = '%s_intra_%s' % (symbol, date)
    self.instance_type = IntraDayData
  
  def DoesKeyExist(self, ssdb_client):
    if ssdb_client.exists('%s_0' % (self.key)):
      return True 

class InterKey(SingleKey):
  def __init__(self, symbol, date):
    self.key = '%s_inter_%s' % (symbol, date)
    self.instance_type = InterDayData

class OptionChainsKey(SingleKey):
  def __init__(self, symbol, date):
    self.key = '%s_option_%s_chain' % (symbol, date)
    self.instance_type = OptionChains

class OptionIntraKey(MultiKey):
  def __init__(self, underlying, date, option):
    self.key = "%s_option_%s_intra_%s" % (underlying, date, option)
    self.instance_type = IntraDayData

#class PairedKey(MultiKey):
#   def __init__(self, underlying, date, option):
#    self.key = "%s_option_%s_intra_%s" % (underlying, date, option)
#    self.instance_type = PairedData 

class PairedKey(SingleKey):
   def __init__(self, underlying, date, option):
    self.key = "%s_option_%s_intra_%s" % (underlying, date, option)
    self.instance_type = PairedData 

class LiborKey(SingleKey):
  def __init__(self, libor_code, date):
    self.key = '%sLIB.X_inter_%s' % (libor_code, date)
    self.instance_type = InterDayData

class DividendKey(SingleKey):
  def __init__(self, symbol, date):
    self.key = '%s_dividend_%s' % (symbol, date)
    self.instance_type = DividendData


