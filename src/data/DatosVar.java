package data;


public class DatosVar {
	public String tipo;
	public String ID;
	public Object valor;
	
	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getId() {
		return ID;
	}

	public void setId(String id) {
		this.ID = id;
	}

	public Object getValor() {
		return valor;
	}

	public void setValor(Object valor) {
		this.valor = valor;
	}

	public DatosVar(String tipo, String ID, Object valor) {
		super();
		this.tipo = tipo;
		this.ID = ID;
		this.valor = valor;
	}
	
	public DatosVar(String id) {
		this.ID = id;
	}
	
	public DatosVar() {}
	
	
	public void valorPorDefecto(String tipo) {
		this.tipo = tipo;
		if(tipo == "buleano") this.valor = false;
		else if (tipo == "real") this.valor = 0.0;
		else if (tipo == "entero") this.valor = 0;
		else if (tipo == "caracter") this.valor = '\0';
	}

	public String toString() {
		return "Variable [tipo=" + tipo + ", id=" + ID + ", valor=" + valor + "]";
	}
	
	public String toString2() {
		return "Variable [tipo=" + tipo + ", id=" + ID + "]";
	}

}
