/* 
   EN: Support for a centralized certificate store
   RU: Поддержка централизованного хранилища сертификатов
   --------------------------
   (с) 2022-2023 Разживин Александр | Razzhivin Alexander
   kotyara12@yandex.ru | https://kotyara12.ru | tg: @kotyara1971
*/

#ifndef __ME_CERTS_H__
#define __ME_CERTS_H__

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

bool initTlsGlobalCAStore();
void freeTlsGlobalCAStore();

#ifdef __cplusplus
}
#endif

#endif // __ME_CERTS_H__
