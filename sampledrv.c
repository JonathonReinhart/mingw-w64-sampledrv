#include <wdm.h>

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
