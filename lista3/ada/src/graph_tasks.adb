with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_Io; use Ada.Text_IO.Unbounded_IO;
package body graph_tasks is
   
   task body TaskSender is
      newPacket : Packet_Access;
      str : Unbounded_String;
   begin
      loop
         delay Duration(Integer(random(gen)) mod Sending_Delay);
         newPacket := new Packet'(myNode.index, Integer_Vectors.Empty_Vector, Integer_Vectors.Empty_Vector);
         myNode.routingTable.CreatePacket(newPacket);
         if not newPacket.costs.Is_Empty then
            str := To_Unbounded_String("Pakiet zostal wyslany z ");
            Append(str, Integer'Image(myNode.index));
            Append(str, " do ");
            for J in myNode.neighbours.First_Index .. myNode.neighbours.Last_Index loop
               Append(str, Integer'Image(myNode.neighbours(J)));
            end loop;
            Messager.Print(Ada.Strings.Unbounded.To_String(str));
            for J in myNode.neighbours.First_Index .. myNode.neighbours.Last_Index loop
               receivers(myNode.neighbours(J)).Send(newPacket);
            end loop;
         end if;
      end loop;
   end TaskSender;
   
   task body TaskReceiver is
      packet : Packet_Access;
      str : Unbounded_String;
   begin
      loop
         --Put_Line(Integer'Image(myNode.index));
         accept Send (myPacket : Packet_Access) do
            packet := myPacket;
            str := To_Unbounded_String("Pakiet zostal odebrany w ");
            Append(str, Integer'Image(myNode.index));
            Append(str, " z ");
            Append(str, Integer'Image(packet.neighbourIndex));
            Messager.Print(Ada.Strings.Unbounded.To_String(str));
            str := To_Unbounded_String("");
            myNode.routingTable.HandlePacket(myNode.index, packet, str);
            if str /= "" then
               Messager.Print(Ada.Strings.Unbounded.To_String(str));
            end if;
         end Send;
      end loop;
   end TaskReceiver;
   
   task body Messager is
   begin
      loop
         select
            accept Print (msg : in String) do
               Put_Line (msg);
            end Print;
         or
            terminate;
         end select;
      end loop;
   end Messager;

end graph_tasks;
