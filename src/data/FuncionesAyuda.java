package data;

import java.util.*;

public class FuncionesAyuda {

	public static Float toReal (Object e) throws Exception{
		Float resultado = 0f;
		if (e.getClass().getSimpleName().equals("Character")) {
			int num_val = (int) ((char)e);
			resultado = Float.parseFloat(Integer.toString(num_val));
		}else{
			try {
				resultado = Float.parseFloat((e.toString()));
			}catch (Exception error) {
				return null;
			}
		}
			return resultado;
	}

	public static Integer toInteger (Object e) throws Exception {
		int resultado = 0;
		if (e.getClass().getSimpleName().equals("Character")) {
			int num_val = (int) ((char)e);
			resultado = Integer.parseInt(Integer.toString(num_val));
		}else {
			try {
				resultado = Math.round(Float.valueOf(e.toString()));
			}catch (Exception error) {
				System.out.println("El valor pasado por parámetro no es un valor capaz de ser convertido a entero");
			}
		}
		return resultado;
	}
	
	public static int buscarVariable(ArrayList<DatosVar> lista, String ID) {
		int resultado = -1;
		int index = 0;
		for(DatosVar siguiente: lista) {
			if(siguiente.getId().equals(ID)) {
				resultado = index;
				break;
			}
			index++;
		}
		return resultado;
	}
	
	public static int buscarRegistro(ArrayList<TablaRegistro> lista, String ID) {
		int resultado = -1;
		int index = 0;
		for(TablaRegistro siguiente: lista) {
			if(siguiente.getNombreRegistro().equals(ID)) {
				resultado = index;
				break;
			}
			index++;
		}
		return resultado;
	}
	
	public static DatosVar obtenerValor(String id, ArrayList<DatosVar> symbolTable) {
		String[] arrayID =  id.split("-");
		ArrayList<String> listaID = new ArrayList<String>();
		for(int i =0; i<arrayID.length; i++) {
			listaID.add(arrayID[i]);
		}
		String idPadre = listaID.get(0); listaID.remove(0);
		 int index = FuncionesAyuda.buscarVariable(symbolTable, idPadre);
		 if(index == -1) return null;
		 ArrayList<DatosVar> obtenerVar = symbolTable.get(index).estructura;
		 DatosVar objetivo = symbolTable.get(index);
		while(!listaID.isEmpty()){ 
			String idHijo = listaID.get(0); listaID.remove(0);
			index = FuncionesAyuda.buscarVariable(obtenerVar,idHijo);
			if(index == -1) return null;
			objetivo = obtenerVar.get(index);
			obtenerVar = obtenerVar.get(index).estructura;
		}
		 return objetivo;
	}
	
}
