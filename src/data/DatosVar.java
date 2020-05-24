package data;

import java.util.ArrayList;

public class DatosVar implements Cloneable{
	public String tipo;
	public String ID;
	public Object valor;
	public ArrayList<DatosVar> estructura = new ArrayList<DatosVar>();
	
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
	
	
	public boolean valorPorDefecto(String tipo, ArrayList<TablaRegistro> lista) throws CloneNotSupportedException {
		this.tipo = tipo;
		if(tipo == "buleano") this.valor = false;
		else if (tipo == "real") this.valor = 0.0;
		else if (tipo == "entero") this.valor = 0;
		else if (tipo == "caracter") this.valor = '\0';
		else {
			int index = FuncionesAyuda.buscarRegistro(lista, tipo);
			if(index == -1) return true;
			DatosVar nuevo = new DatosVar();
			for(DatosVar siguiente: lista.get(index).registro) {
				try {
					nuevo = (DatosVar)siguiente.clone();
				}catch(CloneNotSupportedException e) {
					System.out.println("Error al copiar por default");
				}
				
				this.estructura.add(nuevo);
			}
		}
		return false;
	}

	public String toString() {
		String salida = "";
		if(this.estructura != null) {
			ArrayList<DatosVar> nuevasVariables = estructura;
			for (DatosVar siguiente: nuevasVariables){
				salida = salida+"\n----" + siguiente.toString();
			}
		}
		return "Variable [tipo=" + tipo + ", id=" + ID + ", valor=" + valor + "]" + salida;
	}
	
	public String toString2() {

		return "Variable [tipo=" + tipo + ", id=" + ID + "]";
	}

}
