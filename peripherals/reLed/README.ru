﻿# Библиотека для простого управления одним или несколькими светодиодами. 

Поддерживаются режимы включение/выключение, серии вспышек, мигание (равномерное или сериями). Светодиодов может быть один или несколько, для каждого светодиода создается своя задача FreeRTOS, либо используйте "системный" светодиод (задача для системного светодиода будет создана автоматически).

Поддерживается включение светодиода как с помощью установки высокого уровня, так и низкого (в зависимости от схемы подключения светодиода). Кроме того, поддерживается работа не только с GPIO микроконтроллера, но и управление светодиодами через I2C платы расширения типа PCF8574 с помощью пользовательской функции обратного вызова.

Имеется возможность принудительно подавить вспышки светодиода на какое-то время (например, можно гасить светодиоды на устройствах в ночное время, дабы не мешать сну). 

Расширение библиотеки для "системного" светодиода reLedSys позволяет осуществлять индикацию состояния устройства с помощью одного светодиода (как в автосигнализациях и принтерах). Кроме того, функции системного светодиода можно использовать в самых разных местах кода, не задумываяь о том, к какому выводу и как подключен основной светодиод.

Описание : https://kotyara12.ru/pubs/iot/led32/

============================================================================================
ИСПОЛЬЗОВАНИЕ

Для создания задачи управления светодиодом используйте функцию ledTaskCreate:

ledQueue_t ledTaskCreate(const int8_t ledGPIO, const bool ledHigh, const char* taskName, ledCustomControl_t customControl);

где:
ledGPIO - номер вывода, к которому подключен светодиод.
ledHigh - true = включение с помощью установки на GPIO высокого уровня, false = с помощью установки на GPIO низкого уровня.
taskName - имя задачи, например "ledRed" или "ledAlarm".
customControl - функция обратного вызова для управления адресными светодиодами или платами расширения (например PCF8574). Если не требуется, укажите NULL.

Возвращаемое значение - указатель на экземпляр очереди, связанной с запущенной задачей (не задачи!). 

После этого, можно отправлять команды на переключение режима работы в созданную очередь, используя следующую функцию:

bool ledTaskSend(ledQueue_t ledQueue, ledMode_t msgMode, uint16_t msgValue1, uint16_t msgValue2, uint16_t msgValue3);

где:
ledQueue - указатель на очередь, созданную в ledTaskCreate(...).
msgMode - устанавливаемый режим работы (или команда), перечень возможных команд см. ниже
msgValue1, msgValue2, msgValue3 - передаваемые значения. Для некоторых команд значения не требуется, укажите 0 или любое другое число.

============================================================================================
РЕЖИМЫ РАБОТЫ / УПРАВЛЯЮЩИЕ КОМАНДЫ 

lmEnable
----------------
Блокировка и разблокировка светодиода (например, подавление любой активности в ночное время)
Формат: lmEnable «состояние» (например: «lmEnable 0» или «lmEnable 1»)


lmOff			
----------------
Выключить светодиод
Формат: lmOff (параметры игнорируются)
¯¯¯|______________________________________________________________
   ^

lmOn			
----------------
Включить светодиод
Формат: lmOn (параметры игнорируются)
___|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
   ^

lmFlash
----------------
Одна или несколько вспышек с указанной продолжительностью и интервалом между вспышками
Формат: lmFlash «количество вспышек» «продолжительность вспышек» «пауза между вспышками»
(например, «lmFlash 3 100 500» или «lmFlash 1 250 250»)
___|¯|___|¯|___|¯|________________________________________________
   ^

lmBlinkOn
----------------
Непрерывное мигание: равномерное или сериями (например, три мигания - пауза и т.д.). Чем-то похоже на lmFlash, но не заканчивается на последней вспышке, а продолжается после паузы.
Формат: lmBlinkOn «количество вспышек в серии» «период вспышек в серии» «пауза между сериями»
(например, «lmBlinkOn 1 500 500» - равномерное мигание или «lmBlinkOn 3 100 5000» - мигание сериями вспышек)
Примечание: здесь нельзя установить длительность между вспышками в серии, она берется равной длительности самой вспышки
___|¯|_|¯|_|¯|____...____|¯|_|¯|_|¯|____...____|¯|_|¯|_|¯|____....
   ^
------------------------------------------------------------------
!!! Режим мигания (blinkSet) является автосохраненяемым !!!
------------------------------------------------------------------
Если была получена команда lmBlinkOn, а после нее был активирован любой другой режим (lmOn / lmFlash), то затем после его завершения (команда lmOff или заданное количество миганий для lmFlash) предыдущий режим lmBlinkOn будет автоматически восстановлен (пока он не был отменен командой lmBlinkOff)
------------------------------------------------------------------

lmBlinkOff  
----------------
Отключить мигание (и ожидание следующей команды)
Формат: lmBlinkOff (параметры игнорируются)
_|¯|_|¯|__________________________________________________________
        ^
 
============================================================================================
Пример последовательности команд:

lmOn:                 светодиод включен
lmOff:                светодиод выключен
lmFlash 3 100 500:    светодиод мигнет три раза с длительностью 100 мс с паузой между вспышками по 500 мс, после чего погаснет
lmBlinkOn 2 100 5000: светодиод начинает мигать сериями из 2 вспышек с длительностью 100 мс и паузой между сериями 5000 мс
lmOn:                 светодиод включен, мигание временно приостановлено
lmOff:                возвращаемся к последнему режим мигания (сериями из 2-х миганий по 100 мс через 5 секунд)
lmFlash 30 100 500:   светодиод мигнет 30 раз с длительностью 100 мс с паузой между вспышками 500 мс, после чего снова автоматически возвращаемся в последний режим мигания (сериями из 2-х миганий по 100 мс через 5 секунд)
lmOff:                ничего не изменися ;-)
lmBlinkOn 1 500 500:  изменение режима мигания - непрерывное равномерное мигание 0,5 с горит / 0,5 с не горит
lmBlinkOff:           отключить режим мигания, выключен
