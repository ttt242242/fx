##  -*- Mode: ruby -*-

require 'thread' ;

##======================================================================
module Itk

  ##============================================================
  class ThreadPool

    ##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    attr :max, true ;
    attr :count, true ;
    attr :mutexList, true ;
    attr :queue, true ;
    attr :threadTable, true ;

    ##----------------------------------------
    def initialize(max)
      @max = max ;
      @count = 0 ;
      @mutexList = (0...@max).map{ Mutex.new() } ;
      @threadTable = {} ;
      @queue = Queue.new() ;
      @mutexList.each{|mx| @queue.push(mx)} ;
    end

    ##----------------------------------------
    def nextMutex()
      @count += 1 ;
      return @queue.pop() ;
    end

    ##----------------------------------------
    def releaseMutex(mx)
      return @queue.push(mx) ;
    end

    ##----------------------------------------
    def fork(*args,&block)
      mx = nextMutex() ;
      th = Thread.new() {
        mx.synchronize(*args){|*iargs|
          block.call(*iargs) ;
        }
        self.releaseMutex(mx) ;
      }
      @threadTable[mx] = th ;
      return mx ;
    end

  end




end # module Itk

if($0 == __FILE__) then
  tpool = Itk::ThreadPool.new(10) ;

  (0...100).each{|i|
    tpool.fork(){ 
      r = rand(5) ;
      p [:start, i,  r] ;
      system("sleep #{r}") ;
      p [:end, i, r] ;
    }
  }
end


