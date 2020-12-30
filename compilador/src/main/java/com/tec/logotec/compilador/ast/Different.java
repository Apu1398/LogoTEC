package com.tec.logotec.compilador.ast;

import java.util.Map;

public class Different implements ASTNode {

	private ASTNode operand1;
	private ASTNode operand2;
	
	
	public Different(ASTNode operand1, ASTNode operand2) {
		super();
		this.operand1 = operand1;
		this.operand2 = operand2;
	}
	
	@Override
	public Object execute(Map<String, Object> symbolTable) {
		return ((Object)operand1.execute(symbolTable).equals((Object)operand2.execute(symbolTable)));
	}

}
