---------------------------------------------------------------------------
--           Raspberry Pi NMEA 0183 UART GPS interface
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
package Gps is
   
   subtype Time_Len is Positive range 1 .. 9;
   subtype Lat_Len is Positive range 1 .. 12;
   subtype Lon_Len is Positive range 1 .. 13;   
   
   -----------------------------------------------------------------------------------------
   --
   -- Init Gps UART device   
   --
   -----------------------------------------------------------------------------------------       
   procedure Init(Device : String);
   
   -----------------------------------------------------------------------------------------
   --
   -- De init and close device
   --
   -----------------------------------------------------------------------------------------       
   procedure De_Init;
   
   -----------------------------------------------------------------------------------------
   --
   -- Get time      
   --
   -----------------------------------------------------------------------------------------       
   procedure Get(Time : out String);
   
   -----------------------------------------------------------------------------------------
   --
   -- Get Lat and Lon   
   --
   -----------------------------------------------------------------------------------------       
   procedure Get(Lat : out String; Lon : out String);
   
   -----------------------------------------------------------------------------------------
   --
   -- Get time, Lat and Lon   
   --
   -----------------------------------------------------------------------------------------       
   procedure Get(Time : out String; Lat : out String; Lon : out String);   
end Gps;
