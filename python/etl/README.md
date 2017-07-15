FIrst set up 2 ssdb ports on your computer (details?)



test on AAPL_201405

Testing for import_data.py:

Type command in terminal while in directory ncllc_extern/python/etl:

python import_data.py -m localhost -p 8888 -d ../../AAPL_201405

to check that all the data has been transported to ssdb run:

  python -i (in the command line to use interactive python)

  then in interactive python type: 

  from ssdb import SSDB

  then, ssdb_client_feed = SSDB(host='localhost', port=8888)

  check that all the keys are there by typing ssdb:

  ssdb_client_feed.keys('','', 100000)

  then choose a key to check if everything was transferred to ssdb properly if the key you chose has LIB.X or _inter_ in it:

    from ssdb import SSDB

    ssdb_client_feed = SSDB(host='localhost', port=8888)

    from proto.feed_pb2 import InterDayData

    inter_day_data = InterDayData()

    val = ssdb_client_feed.get(key) -> where key is the key chosen

    inter_day_data.ParseFromString(val)

    print inter_day_data.prices[0]; print inter_day_data.prices[-1]

    what prints should look similar to this:

    timestamp: "2014-05-14 04:19:56"
    high: 0.088
    low: 0.088
    open: 0.088
    close: 0.088
    period_volume: 0
    open_intrest: 0

    timestamp: "2001-01-02 04:19:56"
    high: 6.651
    low: 6.651
    open: 6.651
    close: 6.651
    period_volume: 0
    open_intrest: 0

  if you chose a key with _intra_:

    for instance: 'AAPL_option_20140530_intra_AAPL1517M465_0'
    or 'AAPL_intra_20140528_1'

    then type:

    from ssdb import SSDB

    ssdb_client_feed = SSDB(host='localhost', port=8888)

    from proto.feed_pb2 import IntraDayData

    intra_day_data = IntraDayData()

    val = ssdb_client_feed.get(key) -> where key is the key chosen

    intra_day_data.ParseFromString(val)

    print intra_day_data.ticks[0]; print intra_day_data.ticks[-1]

    should look like this:

      timestamp: "2014-05-01 14:03:51"
      last: 4.95
      last_size: 1
      total_volume: 1
      bid: 4.3
      ask: 4.95
      tick_id: 2675178500
      bid_size: 0
      ask_size: 0
      basis_for_last: "C"

      timestamp: "2014-05-01 15:29:02"
      last: 4.77
      last_size: 10
      total_volume: 11
      bid: 4.75
      ask: 4.85
      tick_id: 3325365700
      bid_size: 0
      ask_size: 0
      basis_for_last: "C"

      type quit to get out of interactive python

To test post_processing.py run in the command line:

 python post_processing.py -hf localhost -hp localhost -f 8888 -p 9008

 **did you want it to print all the target dates

 now type

 ssdb_client_feed.keys('','', 100000)

 Choose a key and check that now all this data has been transferred type python -i again.

  then type:

    from ssdb import SSDB

    from proto.post_processing_pb2 import PairedData

    ssdb_client_post = SSDB(host='localhost', port=9008)

    val = ssdb_client_post.get(key)

    paired_data = PairedData()

    ...

No check black_scholes.py:

run python black_scholes.py
