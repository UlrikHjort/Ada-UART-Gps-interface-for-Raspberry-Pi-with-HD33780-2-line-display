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
with Ada.Text_IO; use Ada.Text_IO;
with HD44780;
with Gps;

procedure Main is
      
   Time : String(Gps.Time_Len) := (others => Character'Val(0));      
   Lat : String(Gps.Lat_Len) := (others => Character'Val(0));            
   Lon : String(Gps.Lon_Len) := (others => Character'Val(0));                     
   
   
begin
   -- Get lat, lon from gps and print it on the HD44780 display
   HD44780.Init;
   HD44780.Set_Cursor_Mode(HD44780.OFF);           
   Gps.Init("/dev/serial0");
   
   loop
      Gps.Get(Lat, Lon);
      HD44780.Print_String_Position(Lat,1,0);    
      HD44780.Print_String_Position(Lon,2,0);   
   end loop;
   
end Main;

