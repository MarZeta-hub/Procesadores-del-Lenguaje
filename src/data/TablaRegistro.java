package data;

import java.util.ArrayList;

public class TablaRegistro {

	public String nombreRegistro;
	public ArrayList<DatosVar> registro = new ArrayList<DatosVar>();
	
	
	public String getNombreRegistro() {
		return nombreRegistro;
	}
	public void setNombreRegistro(String nombreRegistro) {
		this.nombreRegistro = nombreRegistro;
	}
	public ArrayList<DatosVar> getRegistro() {
		return registro;
	}
	public void setRegistro(ArrayList<DatosVar> registro) {
		this.registro = registro;
	}
	
	public TablaRegistro(String nombreRegistro, ArrayList<DatosVar> registro) {
		super();
		this.nombreRegistro = nombreRegistro;
		this.registro = registro;
	}
	
	
}
