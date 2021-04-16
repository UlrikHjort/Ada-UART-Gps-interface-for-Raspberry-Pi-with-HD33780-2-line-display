---------------------------------------------------------------------------
--            Raspberry Pi I/O System Call Interface
-- 
--           Copyright (C) 2021 By Ulrik Hørlyk Hjort
--
--  This Program is Free Software; You Can Redistribute It and/or
--  Modify It Under The Terms of The GNU General Public License
--  As Published By The Free Software Foundation; Either Version 2
--  of The License, or (at Your Option) Any Later Version.
--
--  This Program is Distributed in The Hope That It Will Be Useful,
--  But WITHOUT ANY WARRANTY; Without Even The Implied Warranty of
--  MERCHANTABILITY or FITNESS for A PARTICULAR PURPOSE.  See The
--  GNU General Public License for More Details.
--
-- You Should Have Received A Copy of The GNU General Public License
-- Along with This Program; if not, See <Http://Www.Gnu.Org/Licenses/>.
---------------------------------------------------------------------------
with Interfaces.C.Strings; use Interfaces.C.Strings;

package body IO is
   
   --------------------------------------------------------------------
   --
   -- Open
   --
   --------------------------------------------------------------------       
   function Open(Filename : String; Flags : Mode) return C.Int is
      
      function COpen(Filename : Interfaces.C.Strings.Chars_Ptr; Flags : Mode) return C.Int
	with
	Import        => True,
	Convention    => C,
        External_Name => "open";      
      
      Handle : constant Interfaces.C.Strings.chars_ptr := New_String (Filename);      
   begin
      return COpen(Handle,Flags);
   end Open;
   
   --------------------------------------------------------------------
   --
   -- Close
   --
   --------------------------------------------------------------------       
   function Close(Handle : C.Int) return Integer is
      function CClose(Handle : C.Int) return C.Int
	with
	Import        => True,
	Convention    => C,
        External_Name => "close";            
   begin
      return Integer(CClose(Handle));
   end Close;   
   
   --------------------------------------------------------------------
   --
   -- Ioctl
   --
   --------------------------------------------------------------------       
   function Ioctl(Handle : C.Int; Request : C.Unsigned_Long; Addr : C.Int) return Integer is
      function CIoctl(Handle : C.Int; Request : C.Unsigned_Long; Addr : C.Int) return C.Int
	with
	Import        => True,
	Convention    => C,
        External_Name => "ioctl";            
   begin
      return Integer(CIoctl(Handle, Request, Addr));
   end Ioctl;
   
   
   --------------------------------------------------------------------
   --
   -- Write
   --
   --------------------------------------------------------------------       
   function Write(Handle : C.Int; Buffer : Byte_Buffer; Length : C.Int) return Integer is
      function CWrite(Handle : C.Int; Buffer : Byte_Buffer; Length : C.Int)  return C.Int
	with
	Import        => True,
	Convention    => C,
        External_Name => "write";                  
   begin
      return Integer(CWrite(Handle, Buffer, Length));
   end Write;
   
   --------------------------------------------------------------------
   --
   -- Read
   --
   --------------------------------------------------------------------       
   function Read(Handle : C.Int; Buffer : Byte_Buffer; Length : C.Int) return Integer is
      function CRead(Handle : C.Int; Buffer : Byte_Buffer; Length : C.Int)  return C.Int
	with
	Import        => True,
	Convention    => C,
        External_Name => "read";                  
   begin
      return Integer(CRead(Handle, Buffer, Length));      
   End Read;
   
   --------------------------------------------------------------------
   --
   -- Perror
   --
   --------------------------------------------------------------------       
   procedure Perror(Error_Message : String) is
      procedure CPerror(Error_Message : Interfaces.C.Strings.chars_ptr) 
	with
	Import        => True,
	Convention    => C,
        External_Name => "perror";            
      S : constant Interfaces.C.Strings.chars_ptr := New_String (Error_Message);            
      
   begin
      CPerror(S);
   end Perror;
      
end IO;
