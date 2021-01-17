package com.tec.logotec.compilador.ast;

import java.util.List;

public class Ultimo implements ASTNode {

	private List<ASTNode> mathExpressions;
	

	public Ultimo(List<ASTNode> mathExpressions) {
		super();
		this.mathExpressions = mathExpressions;
	}
	
	
	@Override
	public Object execute(Context symbolTable) {
		return mathExpressions.get(mathExpressions.size() - 1).execute(symbolTable);
	}

}
