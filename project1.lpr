{
 если просто копируете, то УДАЛЯЙТЕ КОММЕНТАРИИ
 пишите только маленькие поправочные
 ПО МОЕМУ ОБЪЁМУ комментариев он вычисляет что это скорее всего писал я
 он меня ска ЗАПОМНИЛ с прошлого года
 И даёт какую-нибудь невъебенную задачу посложнее, дополняя эту
}
program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

const
  // КОЛИЧЕСТВО ЭЛЕМЕНТОВ в массиве - используется в функциях и процедурах
  // в виде константы, чтобы НЕ передавать каждый раз через параметры
  N = 5;
  // ИМЯ ФАЙЛА в виде константы для простоты использования
  FILE_NAME = 'massivs.dat';

type
  {тип массива целых чисел}
  // T перед Mas обозначает тип(можно без T - для красоты)
  TMas = array[1..N] of integer;

{отдельная процедура для заполнения массива рандомными цыфрами}
// 'var m: TMas' т.к изменяем массив
procedure FillMas(var m: TMas);
var i: integer;
begin
  // N - константа смотри вверху
  for i:=1 to N do
      m[i]:= random(100);  // случайное число [0,99]
end;

{Создать и заполнить файл}
// создаёт файл с 'count' количеством  массивов(уже заполненных) одинаковой длины
procedure CreateFile(name_f: string; count: integer);
var m: TMas; // вспомогательная переменная для записи в файл массивов
    i: integer;
    f: file of TMas; // переменная файлового типа
begin
   // Открываем файл на ЗАПИСЬ
   AssignFile(f, name_f);
   Rewrite(f);
   // Перебираем все массивы (их число = count)
   for i:=1 to count do
   begin
     FillMas(m); // заполняем массив
     // записываем его в файл
     write(f, m);
   end;

closefile(f); // закрываем файл всегда
end;

{Вывести содержимое файла на экран}
procedure ViewFile(name_f: string);
var i: integer;
    m: TMas; // буферная переменная для вывода массива
    f: file of TMas; // переменная файлового типа
begin
   // Открывае файл на ЧТЕНИЕ
   AssignFile(f, name_f);
   Reset(f);

   // считываем массивы из файла до его конца
   while(not eof(f)) do
   begin
     read(f, m);  // считали один массив

     // выводим его
     for i:=1 to N do
         write(m[i]:4); // 4 - отступы ширина поля на одно число

     writeln; // переход на другую строчку
   end;

closefile(f); // закрываем файл всегда
end;

{меняеем порядок элементов в массиве на обратный}
// 'var m: TMas' т.к изменяем массив
procedure reverse(var m: TMas);
var temp: integer; // вспомогательная переменная чтобы менять местами числа в массиве
    i: integer;
begin
  // если идти до конца массива, то элементы вернуться на место
  // поэтому достаточно дойти до половины массива
  for i:=1 to N div 2 do
  begin
     // меняем местами элементы массива, идя с двух концов в середину
     temp:= m[i];
     m[i]:= m[N-i+1];
     m[N-i+1]:= temp;
  end;
end;

{Изменить файл}
// в каждом массиеве меняет порядок элементов на обратный
procedure ChangeFile(name_f:string);
var c: integer; // счётчик зписей - нужен для контроля чтения и записи в файл
    m: TMas; // буферная переменная для вывода массива
    f: file of TMas; // переменная файлового типа
begin
   // Открываем типизированный файл на ЧТЕНИЕ и ЗАПИСЬ
   AssignFile(f, name_f);
   Reset(f);

   {считываем массивы из файла до его конца}
   // начальное положение счётчика записей в файле
   c:= 0;
   while(not eof(f)) do
   begin
     read(f, m);  // считали один массив
     c:= c + 1; // увеличили счётчик

     // изменяем массив
     reverse(m);

     {перезаписываем его на этоже место}
     seek(f, c-1); // ставим указатель перед считанным массивом
     // поверх него записываем новый - изменённый
     write(f, m);
   end;

closefile(f); // закрываем файл всегда
end;

// основная программа
var count: integer;
begin
  randomize; // чтобы случайные числа отличались от запуска к запуску - НЕОБЯЗАТЕЛЬНО

  // Задаём количество массивов в файле
  count := 5; // можнно чтобы пользователь вводил с клавы Но времени нет

  // создали файл
  CreateFile(file_name, count);
  // Выводим файл
  writeln('Файл ДО изменения:');
  ViewFile(file_name);

  // изменили файл
  ChangeFile(file_name);
  // выводим снова его
  writeln; // отступаем строку для красоты
  writeln('Файл ПОСЛЕ изменения:');
  ViewFile(file_name);

  // задержка перед выходом
  readln;
end.
