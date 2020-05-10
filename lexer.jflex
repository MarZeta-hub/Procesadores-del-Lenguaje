package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%ignorecase
%char
%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

/* Control de lineas */
Newline    = \r | \n | \r\n
Whitespace = [ \t\f] | {Newline}

/* Identificador*/
id = [a-zA-Z][a-zA-Z0-9"_""-"]*

/* Numeros Enteros*/
Int = [+-]? ( ( [1-9] [0-9]* ) | "0" ) {Exp}?   //Numeros detectados como enteros
Hexadecimal =  0 [xX] 0* [0-9a-fA-F]+          //Para los números hexadecimales

/* Numeros Reales*/
Real       = ({Double1} | {Double2}) {Exp}? 
Double1    = [+-]? [0-9]+ [.] [0-9]+     //Primer tipo de double
Double2    = [+-]? [.] [0-9]+			 //Segundo tipo de double
Exp        = [eE] [+-]? [0-9]+			 //En el caso de que sea exponencial

/* Booleanos*/
Boolean = "true" | "false"              //Formato de tipo booleano

/* Caracter */
Char = "'" [^] "'"                      //formato Caracter

/* Lógico */
Land = "and" | "&"                     //AND logico
Lor  = "or" | "|"					   //OR logico
Lnot = "not" | "!"  				   //NOT logico


/* Comentarios */
Comment = {TraditionalComment} | {EndOfLineComment} 
TraditionalComment = "<!--" {CommentContent} "-->" //Comentario de abierto y cerrado
EndOfLineComment = "#" [^\r\n]*                   //Comentario de linea
CommentContent = ( [-]* |[^-] | -[^-] | --+[^->])*            //Contenido de comentario

%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {

  {Whitespace} {}
  ";"           { return symbolFactory.newSymbol("SEMI", SEMI); }
  "+"           { return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"           { return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"           { return symbolFactory.newSymbol("TIMES", TIMES); }
  "/"           { return symbolFactory.newSymbol("DIV", DIV); }
  "<"           { return symbolFactory.newSymbol("MENOR", MENOR); }
  ">"           { return symbolFactory.newSymbol("MAYOR", MAYOR); }
  "="           { return symbolFactory.newSymbol("IGUAL", IGUAL); }
  "<="          { return symbolFactory.newSymbol("MENORIGUAL", MENORIGUAL); }
  ">="          { return symbolFactory.newSymbol("MAYORIGUAL", MAYORIGUAL); }
  "=="          { return symbolFactory.newSymbol("IGUALIGUAL", IGUALIGUAL); }
  "!="          { return symbolFactory.newSymbol("NOTIGUAL", NOTIGUAL);}
  "n"           { return symbolFactory.newSymbol("UMINUS", UMINUS); }
  "("           { return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"           { return symbolFactory.newSymbol("RPAREN", RPAREN); }
  ":"           { return symbolFactory.newSymbol("DPTOS", DPTOS); }
  "{"           { return symbolFactory.newSymbol("LCORCH", LCORCH); }     
  "}"           { return symbolFactory.newSymbol("RCORCH", RCORCH); }
  ","           { return symbolFactory.newSymbol("COMA", COMA); }
  "."           { return symbolFactory.newSymbol("PUNTO", PUNTO);}
  {Land}        { return symbolFactory.newSymbol("AND",AND); }
  {Lor }        { return symbolFactory.newSymbol("OR", OR); }
  {Lnot}        { return symbolFactory.newSymbol("NOT", NOT); }
  "ENTERO"      { return symbolFactory.newSymbol("DENTERO", DENTERO);}
  "REAL"        { return symbolFactory.newSymbol("DREAL", DREAL);}
  "CARACTER"    { return symbolFactory.newSymbol("DCARACTER", DCARACTER);}
  "BULEANO"    { return symbolFactory.newSymbol("DBOOLEAN", DBOOLEAN);}
  "RETURN"      { return symbolFactory.newSymbol("RETURN", RETURN);}
  "FUNCION"     { return symbolFactory.newSymbol("FUNCION", FUNCION);}
  "MIENTRAS"     { return symbolFactory.newSymbol("MIENTRAS", MIENTRAS);}
  "FINMIENTRAS" { return symbolFactory.newSymbol("FINMIENTRAS", FINMIENTRAS );}
  "ENTONCES"    { return symbolFactory.newSymbol("ENTONCES", ENTONCES );}
  "Struct"      { return symbolFactory.newSymbol("STRUCT", STRUCT );}
  "SI"          { return symbolFactory.newSymbol("SI", SI );}
  "SINO"        { return symbolFactory.newSymbol("SINO", SINO );}
  "FINSI"       { return symbolFactory.newSymbol("FINSI", FINSI );}
  {Int}         { return symbolFactory.newSymbol("NUMBER", NUMBER, Double.parseDouble(yytext()));}
  {Real}        { return symbolFactory.newSymbol("NUMBER", NUMBER, Double.parseDouble(yytext()));}
  {Hexadecimal} { return symbolFactory.newSymbol("NUMBER", NUMBER, (double) Integer.parseInt(yytext().substring(2), 16)); }
  {Boolean}     { return symbolFactory.newSymbol("BOOLEAN", BOOLEAN, Boolean.parseBoolean(yytext()));}
  {Char}        { return symbolFactory.newSymbol("CHAR", CHAR, yytext().charAt(1) );}
  {id}          { return symbolFactory.newSymbol("ID", ID);}
  {Comment}     { }    /* IGNORAMOS LOS COMENTARIOS */
}

// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
