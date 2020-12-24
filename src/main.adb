with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   size: Integer := 50000;
   num_of_threads: Integer := 4;
   num_of_thread_elements: Integer := size / num_of_threads;
   type my_arr is array(0..size-1) of Long_Integer;

   task part_sum is
      entry start(arr: my_arr; num_of_thread: Integer);
      entry finish(rezult: out Long_Integer);
   end part_sum;

task body part_sum is
      sum: Long_Integer := 0;
      array_begin: Integer := 0;
      array_end: Integer := 0;
   begin
      loop
         select

            accept start(arr: my_arr; num_of_thread: Integer) do

               array_begin := num_of_thread * num_of_thread_elements;
               array_end := (num_of_thread + 1) * num_of_thread_elements - 1;

               for i in array_begin..array_end loop
                  sum := sum + arr(i);
               end loop;

            end start;
         or
            accept finish(rezult: out Long_Integer) do
               rezult := sum;
               sum := 0;
            end finish;
         or
            delay 1.0;
            exit;
         end select;
      end loop;
   end part_sum;

   rezult: Long_Integer := 0;
   part_rez: Long_Integer := 0;
   arr: my_arr;
begin

   for i in 0..size-1 loop
      arr(i) := long_integer(i);
   end loop;

  for i in 0..3 loop
      part_sum.start(arr, i);
      part_sum.finish(part_rez);
      rezult := rezult + part_rez;
   end loop;

   Put_Line(rezult'Img);
end Main;

