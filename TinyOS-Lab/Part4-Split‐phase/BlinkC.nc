/*
 * HUST IOT TinyOS Lab Part IV - Split phase
 *
 * By Pan Yue, modifyed from tinyos/apps/Blink/BlinkC.nc
 */

#include "Timer.h"
#include "printf.h"

module BlinkC @safe()
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Timer<TMilli> as Timer1;
  uses interface Timer<TMilli> as Timer2;
  uses interface Leds;
  uses interface Boot;
}

implementation
{
  event void Boot.booted()
  {
    call Timer0.startPeriodic( 250 );
    call Timer1.startPeriodic( 500 );
    call Timer2.startPeriodic( 1000 );
  }

  uint32_t i;
  task void computeTask()
  {
    uint32_t tmp = i;
    for (;i < tmp + 10000 && i < 400001; i++) {}
    if (i > 400000) {
      i = 0;
    }
    else {
      post computeTask();
    }
  }

  event void Timer0.fired()
  {
    dbg("BlinkC", "Timer 0 fired @ %s.\n", sim_time_string());
    printf("LED Toggle: 0\n");
    call Leds.led0Toggle();
    post computeTask();
  }

  event void Timer1.fired()
  {
    dbg("BlinkC", "Timer 1 fired @ %s \n", sim_time_string());
    printf("LED Toggle: 1\n");
    call Leds.led1Toggle();
  }

  event void Timer2.fired()
  {
    dbg("BlinkC", "Timer 2 fired @ %s.\n", sim_time_string());
    printf("LED Toggle: 2\n");
    call Leds.led2Toggle();
  }
}
