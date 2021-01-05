package com.tec.logotec.compilador.ast;

import java.util.List;

public class Diferencia implements ASTNode {

	private List<ASTNode> parameters; 
	
	public Diferencia( List<ASTNode> parameters) 
	{
		super();
		this.parameters = parameters;
	}

	@Override
	public Object execute(Context symbolTable) 
	{
		
		int resultado = (int) parameters.get(0).execute(symbolTable);
		parameters.remove(0);
		for (ASTNode astNode : parameters) {
			resultado -= (int) astNode.execute(symbolTable);
		}
		
		
		return resultado;
	}

}
