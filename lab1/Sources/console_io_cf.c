/****************************************************************************/
/*


DESCRIPTION

    C MSL interface to the support IO functions provided by the debugger.

    Public functions:

        __read_console() - Read a specified number of characters
            from the console into a buffer.

        __write_console() - Read a specified number of characters
            from a buffer to the console.

        __close_console() - Close the console.


        Function parameters:

            handle (__file_handle): Specifies the console or
                disk file on which to operate.  Disk file
                handles are assigned dynamically.  Console
                file handles are:

                    stdin:  0
                    stdout: 1
                    stderr: 2

            buffer (unsigned char *): For writes, points to
                the data which is to be written.  For reads,
                points to storage for the data which will
                be read.

            count (size_t *): The desired number of characters
                to read/write.  The value after calling
                a particular function indicates the actual
                number of characters read/written.

        Return value:  All of the public functions here return
            a value of type 'enum __io_results' as defined
            in stdio.h in the Metrowerks MSL.


AUTHORS

    (c) 1998 Metrowerks Corporation
    All rights reserved.

*/

#include <ansi_parms.h>

#if _EWL_CONSOLE_SUPPORT

#include <console_io.h>

#ifndef __cplusplus
typedef int             bool;
static const bool false = 0;
static const bool true  = 1;
#endif

static long __access_file( __std(__file_handle) handle, unsigned char * buffer,
                          __std(size_t) * count, bool read );


/*
 * The result of an I/O command can be any one of the following.
 */

typedef enum DSIOResult
{
    kDSIONoError    = 0x00,
    kDSIOError      = 0x01,
    kDSIOEOF        = 0x02
} DSIOResult;

/*
 *    MessageCommandID
 */
typedef enum MessageCommandID
{
    /*
     * target->host support commands
     */

    kDSWriteFile                = 0xD0,        /*        L2    L3        */
    kDSReadFile                 = 0xD1         /*        L2    L3        */

} MessageCommandID;

/**************************************************************************
 *
 *    TRKAccessFile
 *
 *    Read/Write the specified amount of data from/to the file specified by
 *    handle to/from the given buffer.  The location referenced by count
 *    is updated with the actual number of bytes read/written
 *
 *    Input parameters
 *        Command            kDSReadFile or kDSWriteFile
 *        File Handle        one of DSFileHandle values
 *        Count ptr          ptr to storage for the resulting count read/written
 *        Buffer ptr         ptr to storage buffer
 *
 *    Output:
 *        IO Result        one of DSIOResult values
 *
 **************************************************************************/

static asm __declspec(register_abi) unsigned char TRKAccessFile(long command, unsigned long file_handle, unsigned long *length_ptr, char *buffer_ptr)
{
    move.l    D3,-(a7)
    andi.l    #0x000000ff, D0
    move.l    A1, D3
    movea.l    A0, A1
    move.l    (A1),D2
    trap    #14
    move.l    D1, (A1)
    move.l    (A7)+,D3
    rts
}

/****************************************************************************/
/*
 *    __access_file
 *
 *    Read/Write the specified amount of data from/to the file specified by
 *    handle to/from the given buffer.
 */
/****************************************************************************/

static long __access_file( __std(__file_handle) handle, unsigned char * buffer,
                   __std(size_t) * count, bool read )
{
    unsigned long local_count;
    long result;

    /*
    ** Convert MSL types (loosely specified sizes and forms) into
    ** types with well-defined sizes and forms.
    */

    local_count = *count;

    result = TRKAccessFile( (read ? kDSReadFile : kDSWriteFile),
                            (unsigned long)handle, &local_count,
                            (char *)buffer );

    *count = (__std(size_t))local_count;

    /*
    ** Convert the result into the MSL equivalent.
    */

    switch (result)
    {
        case kDSIONoError:
            return( __std(__no_io_error) );
        case kDSIOEOF:
            return( __std(__io_EOF) );
        case kDSIOError:
        default:
            return( __std(__io_error) );
    }
}

/****************************************************************************/
/*
 *    __read_console
 *
 *    Read the specified amount of data from the console file specified by
 *    handle into the given buffer.
 */
/****************************************************************************/

int __read_console( __std(__file_handle) handle, unsigned char * buffer,
                    __std(size_t) * count)
{
#pragma unused(handle)
    return __access_file(0,buffer,count,true);
}

/****************************************************************************/
/*
 *    __write_console
 *
 *    Write the specified amount of data to the console file specified by
 *    handle from the given buffer.
 */
/****************************************************************************/

int  __write_console( __std(__file_handle) handle, unsigned char * buffer,
                      __std(size_t) * count)
{
#pragma unused(handle)
    return __access_file(0,buffer,count,false);
}

int __close_console( __std(__file_handle) handle )
{
    #pragma unused( handle )
    return( __std(__no_io_error) );
}

#endif /* _EWL_CONSOLE_SUPPORT   */

