
{$mode objfpc}     // directive to be used for defining classes
{$m+}		   // directive to be used for using constructor

Program TextAdventure(output);
uses CRT, sysutils;

//STRUCT OBJETO
type Objeto = record
        id, tipo, cena_alvo: integer;
        nome, descricao, result_posit, result_negat, comand_correct: string;
        resolvido, obtido: boolean;
end;


//STRUCT CENA
type Cena = record
        id, qtd_objetos: integer;
        titulo, descricao: string;
        itens: array[0..10] of Objeto;
end;


//STRUCT JOGO
type Jogo = record
        cena_atual: integer;
        cenas: array[0..10] of Cena;
end;


//STRUCT IVENTARIO
type Inventario = record
        itens: array[0..10] of Objeto;
        freePos: integer;
end;

function criaObjeto(id_objeto, tipo : integer; nome, descricao_objeto, result_posit, result_negat, comand_correct : string; cena_alvo : integer) : Objeto;
var
    obj : Objeto;
begin
    obj.id := id_objeto;
    obj.tipo := tipo;
    obj.nome := nome;
    obj.descricao := descricao_objeto;
    obj.result_posit := result_posit;
    obj.result_negat := result_negat;
    obj.comand_correct := comand_correct;
    obj.cena_alvo := cena_alvo;
    obj.obtido := false;
    obj.resolvido := false;

    criaObjeto := obj;
end;

function criaCena(ident : integer; tit, desc : string; qtd_objetos : integer) : Cena;
var
        scene : Cena;
begin
        scene.id := ident;
        scene.titulo := tit;
        scene.descricao := desc;
        scene.qtd_objetos := qtd_objetos;
        criaCena := scene;
end;

function posNoInv (inv : Inventario; obj : Objeto) : integer;
var
        i : integer;
begin
        for i := 0 to inv.freePos-1 do
        begin
                if inv.itens[i+1].nome = obj.nome then
                begin
                        posNoInv := i;
                end;
        end;
        posNoInv := -1;
end;


procedure printaInventario (inv : Inventario; freePos : integer);
var
        i : integer;
begin
        for i:= 0 to freePos-1 do
        begin
                write(inv.itens[i].nome);
                write(' ');
        end;

end;

function criaJogo () : Jogo;
var
    arq: text;
    linha, titulo, descricao_cena, descricao_objeto, nome, comando_correto, resultado_positivo, resultado_negativo : string;
    i, j, id_objeto, qtd_objetos, tipo, cena_alvo : integer;
    id_cena : integer;
    game : Jogo;


begin
        Assign(arq,'./Files/Cenas.txt');
        reset(arq);
        i := 0;
        while not EOF(arq) do
         begin
        readln(arq, linha);  //Linha magica q nao deixa o prog voar heheeh S2
        readln(arq, id_cena);
        //writeln(id_cena);
        readln(arq, titulo);
        //writeln(titulo);
        readln(arq, descricao_cena);
        //writeln(descricao_cena);
        readln(arq, qtd_objetos);
        //writeln(qtd_objetos);

        game.cenas[i] := criaCena(id_cena, titulo, descricao_cena, qtd_objetos);


   for j:=0 to qtd_objetos - 1 do
    begin
        readln(arq, id_objeto);
        //writeln(id_objeto);
        readln(arq, tipo);
        //writeln(tipo);
        readln(arq, nome);
        //writeln(nome);
        readln(arq, descricao_objeto);
        //writeln(descricao_objeto);
        readln(arq, resultado_positivo);
        //writeln(resultado_positivo);
        readln(arq, resultado_negativo);
        //writeln(resultado_negativo);
        readln(arq, comando_correto);
        //writeln(comando_correto);
        cena_alvo := i;
        game.cenas[i].itens[j] := criaObjeto(id_objeto, tipo, nome, descricao_objeto, resultado_positivo, resultado_negativo, comando_correto, cena_alvo);
    end;
    i := i + 1;
    end;
	close(arq);
    criaJogo := game;
end;

procedure printaCena (scene : Cena);
var
    i : integer;
begin
        writeln('##XxCENAxX##');
        writeln(scene.titulo);
        writeln(scene.descricao);
        //writeln('##XxCENA-OBJETOSxX##');
        //for i:=0 to scene.qtd_objetos-1 do
        //begin
            //writeln(scene.itens[i].nome);
            //write('Comando Correto: ');
            //writeln(scene.itens[i].comand_correct);
        //end;
end;

type
  TSarray = array of string;

function Split(Texto, Delimitador: string): TSarray;

var
  o: integer;
  PosDel: integer;
  Aux: string;

begin

  o := 0;
  Aux := Texto;
  SetLength(Result, Length(Aux));

  repeat

    PosDel := Pos(Delimitador, Aux) - 1;

    if PosDel = -1 then
    begin
      Result[o] := Aux;
      break;
    end;

    Result[o] := copy(Aux, 1, PosDel);
    delete(Aux, 1, PosDel + Length(Delimitador));
    inc(o);
  until Aux = '';
end;

procedure motorzera (game : Jogo);
var
        kbImput : string; i : integer;
        invent : Inventario;
begin
        //show initial screen
        game.cena_atual := 0;
        invent.freePos := 0;

        printaCena(game.cenas[game.cena_atual]);
        while kbImput <> 'quit' do
        begin
                readln(kbImput);


                if kbImput = 'inventory' then
                begin
                    printaInventario(invent, invent.freePos);
                end;


                for i:=0 to game.cenas[game.cena_atual].qtd_objetos-1 do
                begin
                        if Split(kbImput, ' ').[1] = game.cenas[game.cena_atual].itens[i].nome then
                        begin
                                if Split(kbImput, ' ').[0] = 'check' then
                                begin
                                        writeln(game.cenas[game.cena_atual].itens[i].descricao);
                                end;

                                //tipos
                                if game.cenas[game.cena_atual].itens[i].tipo = 0 then
                                begin

                                        if Split(kbImput, ' ').[0] = 'get' then
                                        begin
                                                if leftStr(game.cenas[game.cena_atual].itens[i].comand_correct, 3) = 'get' then
                                                begin
                                                        if game.cenas[game.cena_atual].itens[i].obtido = false then
                                                        begin
                                                                game.cenas[game.cena_atual].itens[i].obtido := true;
                                                                invent.itens[invent.freePos] := game.cenas[game.cena_atual].itens[i];
                                                                invent.freePos := invent.FreePos + 1;
                                                                writeln(game.cenas[game.cena_atual].itens[i].result_posit);
                                                        end;
                                                        //adicionar else para result negativo
                                                end;
                                        end;
				end;
				if game.cenas[game.cena_atual].itens[i].tipo = 1 then
				begin
                                        if Split(kbImput, ' ').[0] = 'use' then
                                        begin
                                                if leftStr(game.cenas[game.cena_atual].itens[i].comand_correct, 3) = 'use' then
                                                begin
                                                        if game.cenas[game.cena_atual].itens[i].resolvido = false then
                                                        begin
								game.cenas[game.cena_atual].itens[i].resolvido := true;
								writeln(game.cenas[game.cena_atual].itens[i].result_posit);
								game.cena_atual := game.cena_atual + 1;
                                			end; //if
						end; //if
					end; //if split
                        	end; //if tipo = 1

				if game.cenas[game.cena_atual].itens[i].tipo = 2 then
				begin
					if (Split(kbImput, ' ').[0] = 'use') and  (Split(kbImput, ' ').[2] = 'with') then
					begin
                                                //ver se esta no inventario
                                                //tirar do inventario
                                                //mudar o estado
                                                //mudar a cena

					end;
				end;

                	end; // if split[1] = item
        	end; // for
	end; // while
end; // procedure

var
        game : Jogo;
        title : text;
        linha, kbImput, um : string;

begin
clrscr();                                       //Limpa o console

        Assign(title,'./Files/Title.txt');
        reset(title);
        while not EOF(title) do
        begin
          readln(title, linha);
          writeln(linha);
          Delay(200);
        end;
        close(title);

        clrscr();                               //Limpa o console
        Delay(1000);

        game := criaJogo();

        //printaCena(game.cenas[1]);
        motorzera(game);
        readln(kbImput);                        //so para congelar o texto

        //Delay(1000);

end.
