package com.tec.logotec.compilador.ast;

import java.util.List;


public class Suma implements ASTNode {

private List<ASTNode> parameters; 
	
	public Suma( List<ASTNode> parameters) 
	{
		super();
		this.parameters = parameters;
	}

	@Override
	public Object execute(Context symbolTable) 
	{
		
		int resultado = 0;
		
		for (ASTNode astNode : parameters) {
			resultado += (int) astNode.execute(symbolTable);
		}			
			
		return resultado;	
	}

}
