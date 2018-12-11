/**
 * Bug 1: Excluding this #define causes an error due to
 * redefinition of ‘_InterlockedAdd64’
 *
 *   - ddk/wdm.h:68
 *   - psdk_inc/intrin-impl.h:1078
 *
 * https://stackoverflow.com/a/50871446/119527
 */
#define __INTRINSIC_DEFINED__InterlockedAdd64

//#include <wdm.h>
#include <ntifs.h>	// Triggers Bug 2

DRIVER_INITIALIZE DriverEntry;
DRIVER_UNLOAD DriverUnload;

NTSTATUS NTAPI DriverEntry(PDRIVER_OBJECT DriverObject, PUNICODE_STRING RegistryPath)
{
    (void)RegistryPath;

    DbgPrintEx(DPFLTR_IHVDRIVER_ID, DPFLTR_TRACE_LEVEL, "Hello from %s\n", __FUNCTION__);

    DriverObject->DriverUnload = DriverUnload;

    return STATUS_SUCCESS;
}

VOID NTAPI DriverUnload(PDRIVER_OBJECT DriverObject)
{
    (void)DriverObject;

    DbgPrintEx(DPFLTR_IHVDRIVER_ID, DPFLTR_TRACE_LEVEL, "Goodbye from %s\n", __FUNCTION__);
}
