/* 
   EN: Library for working with schedules
   RU: Библиотека для работы с расписаниями
   --------------------------
   (с) 2021 Разживин Александр | Razzhivin Alexander
   kotyara12@yandex.ru | https://kotyara12.ru | tg: @kotyara1971
*/

#ifndef __RE_SCHEDULER_H__
#define __RE_SCHEDULER_H__

#include <stdbool.h>
  #include "mTypes.h"
#include "project_config.h"
#include "def_consts.h"

#ifdef __cplusplus
extern "C" {
#endif

bool schedulerInit();
void schedulerFree();
bool schedulerRegister(timespan_t* timespan, uint32_t value);

bool schedulerStart(bool createSuspended);
bool schedulerSuspend();
bool schedulerResume();
void schedulerDelete();

bool schedulerEventHandlerRegister();
void schedulerEventHandlerUnregister();

// Silent mode
#if defined(CONFIG_SILENT_MODE_ENABLE) && CONFIG_SILENT_MODE_ENABLE
bool isSilentMode();
#endif // CONFIG_SILENT_MODE_ENABLE

#ifdef __cplusplus
}
#endif

#endif // __RE_SCHEDULER_H__
