with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
package body structures is

  protected body RoutingTable is 
      entry HandlePacket (nodeIndex: Integer; P : in out Packet_Access; msg: in out Unbounded_String) when not inUse is
         newCost: Integer;
      begin
         inUse := True;
         msg := To_Unbounded_String("");
         for J in P.nodeIndexes.First_Index .. P.nodeIndexes.Last_Index loop
            newCost := P.costs(J) + 1;
            if newCost < routingEntries(P.nodeIndexes(J)).cost then
               Append(msg, "Routing Table w: " & Integer'Image(nodeIndex) &
					", dla: " & Integer'Image(P.nodeIndexes(J)) &
					", stary koszt: " & Integer'Image(routingEntries(P.nodeIndexes(J)).cost) &
					", nowy koszt: " & Integer'Image(newcost) &
					", stary hop: " & Integer'Image(routingEntries(P.nodeIndexes(J)).nexthop) &
					", nowyhop: " & Integer'Image(P.neighbourIndex) & CR & LF);
               routingEntries(J).cost := newcost;
               routingEntries(J).nexthop := P.neighbourIndex;
               routingEntries(J).changed := True;
            end if;
         end loop;
         inUse := False;
      end HandlePacket;

      entry CreatePacket (P : in out Packet_Access) when not inUse is
      begin
         inUse := True;
         for J in routingEntries.First_Index .. routingEntries.Last_Index loop
            if routingEntries(J).changed then
               P.nodeIndexes.Append(J);
               P.costs.Append(routingEntries(J).cost);
               routingEntries(J).changed := False;
            end if;
         end loop;
         inUse := False;
      end CreatePacket;
      
      procedure printRoutingTable is
      begin
         for routingEntry of routingEntries loop
            Put(Integer'Image (routingEntry.nexthop) & " ");
            Put(Integer'Image (routingEntry.cost) & " ");
            Put(Boolean'Image (routingEntry.changed) & " ");
            Put_Line("");
         end loop;
      end printRoutingTable;
      
      procedure generateRoutingTable (nodeCount: Integer; index : Integer; neighbours: Integer_Vectors.Vector) is
         nextHop : Integer := 0;
         cost : Integer := 0;
      begin
         for I in 0 .. nodeCount-1 loop
            routingEntries.Append(new RoutingEntry'(index, 0, False));
         end loop;
         for neighbour of neighbours loop
            routingEntries(neighbour).nexthop := neighbour;
            routingEntries(neighbour).cost := 1;
            routingEntries(neighbour).changed := True;
         end loop;
         for J in 0 .. nodeCount-1 loop
            if routingEntries(J).changed = False then
               if index < J then
                  nextHop := index+1;
                  cost := -(index-J);
               else 
                  nextHop := index-1;
                  cost := index-J;
               end if;
               routingEntries(J).nexthop := nextHop;
               routingEntries(J).cost := cost;
               routingEntries(J).changed := True;
            end if;
         end loop;
         routingEntries(index).changed := False;
      end generateRoutingTable;
   end RoutingTable;
   

end structures;
