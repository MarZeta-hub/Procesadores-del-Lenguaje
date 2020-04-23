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
Int = [+-]? ( ( [1-9] [0-9]+ ) | "0")   

/* Numeros Reales*/
Real  = ({Double1} | {Double2}) {Exp}?
Double1    = [+-]? [0-9]+ [.] [0-9]+
Double2    = [+-]? [.] [0-9]+
Exp        = [eE] [+-]? [0-9]+

/* Booleanos*/
Boolean = ( [Tt] [Rr] [Uu] [Ee] ) | ( [Ff] [Aa] [Ll] [Ss] [Ee] )

/* Caracter */
Char = "'" [^] "'"

/* L�gico */

Land = ([Aa][Nn][Dd]) | "&"
Lor  = ([Oo][Rr]) | "|"
Lnot = ([Nn][Oo][Tt]) | "!"


/* Comentarios */
Comment = {TraditionalComment} | {EndOfLineComment} 
TraditionalComment = "<!--" {CommentContent} "-->" //Comentario de abierto y cerrado
EndOfLineComment = "#" [^\r\n]* {Newline}          //Comentario de linea
CommentContent = ([^-]|-[^-]|--+[^->])*            //Contenido de comentario

%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {

  {Whitespace} {                              }
  {Comment}    {}
  ";"          { return symbolFactory.newSymbol("SEMI", SEMI); }
  "+"          { return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"          { return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"          { return symbolFactory.newSymbol("TIMES", TIMES); }
  "/"          { return symbolFactory.newSymbol("DIV", DIV); }
  "<"          { return symbolFactory.newSymbol("MENOR", MENOR); }
  ">"          { return symbolFactory.newSymbol("MAYOR", MAYOR); }
  "="          { return symbolFactory.newSymbol("IGUAL", IGUAL); }
  "n"          { return symbolFactory.newSymbol("UMINUS", UMINUS); }
  "("          { return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"          { return symbolFactory.newSymbol("RPAREN", RPAREN); }
  ":"          { return symbolFactory.newSymbol("DPTOS", DPTOS); }
  "{"          { return symbolFactory.newSymbol("LCORCH", LCORCH); }     
  "}"          { return symbolFactory.newSymbol("RCORCH", RCORCH); }
  {Land}       { return symbolFactory.newSymbol("AND",AND); }
  {Lor }       { return symbolFactory.newSymbol("OR", OR); }
  {Lnot}       { return symbolFactory.newSymbol("NOT", NOT); }
  "ENTERO"     { return symbolFactory.newSymbol("DENTERO", DENTERO);}
  "REAL"       { return symbolFactory.newSymbol("DREAL", DREAL);}
  "CARACTER"   { return symbolFactory.newSymbol("DCARACTER", DCARACTER);}
  "BOOLEAN"    { return symbolFactory.newSymbol("DBOOLEAN", DBOOLEAN);}
  {Int}        { return symbolFactory.newSymbol("INT", INT, Integer.parseInt(yytext())); }
  {Real}       { return symbolFactory.newSymbol("REAL", REAL, Double.parseDouble(yytext()));}
  {Boolean}    { return symbolFactory.newSymbol("BOOLEAN", BOOLEAN, Boolean.parseBoolean(yytext()));}
  {Char}       { return symbolFactory.newSymbol("CHAR", CHAR, yytext().charAt(1) );}
  {id}         { return symbolFactory.newSymbol("id", id);}

}

// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
