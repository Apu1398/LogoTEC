
package com.tec.logotec.compilador;
import java.awt.EventQueue;

import com.tec.logotec.compilador.window.VentanaPrincipal;

public class Main {

	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					VentanaPrincipal window = new VentanaPrincipal();
					window.frmLogotec.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

}
