package com.tec.logotec.compilador.ast;

import java.util.List;

public class Primero implements ASTNode {


	private List<ASTNode> mathExpressions;
	

	public Primero(List<ASTNode> mathExpressions) {
		super();
		this.mathExpressions = mathExpressions;
	}
	
	
	@Override
	public Object execute(Context symbolTable) {
		if(mathExpressions.size() != 0) {
			return mathExpressions.get(0).execute(symbolTable);			
		}else {
			return null;
		}
	}
}
