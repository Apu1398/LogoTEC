package com.tec.logotec.compilador.ast;



public class Potencia implements ASTNode {

	private ASTNode base;
	private ASTNode potencia;
	
	
	public Potencia(ASTNode operand1, ASTNode operand2) {
		super();
		this.base = operand1;
		this.potencia = operand2;
	}

	
	@Override
	public Object execute(Context symbolTable) {
		int resultado = 1;
		int veces = (int)potencia.execute(symbolTable);
		for (int i = 0; i < veces; i++) {
			resultado *= (int)base.execute(symbolTable);
		}
		//(int)base.execute(symbolTable)      (int)potencia.execute(symbolTable)
		return resultado;
	}

}
