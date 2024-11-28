call c:\PlatformIO\libs\pack_repo.cmd c:\PlatformIO\libs\certs
call c:\PlatformIO\libs\pack_repo.cmd c:\PlatformIO\libs\consts
call c:\PlatformIO\libs\pack_repo.cmd c:\PlatformIO\libs\sensors

for /D %%z in (c:\PlatformIO\libs\clouds\*.*) do call c:\PlatformIO\libs\pack_repo.cmd %%z
for /D %%z in (c:\PlatformIO\libs\system\*.*) do call c:\PlatformIO\libs\pack_repo.cmd %%z
for /D %%z in (c:\PlatformIO\libs\peripherals\*.*) do call c:\PlatformIO\libs\pack_repo.cmd %%z
for /D %%z in (c:\PlatformIO\libs\wifi\*.*) do call c:\PlatformIO\libs\pack_repo.cmd %%z

pause