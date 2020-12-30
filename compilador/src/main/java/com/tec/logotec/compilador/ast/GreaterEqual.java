package com.tec.logotec.compilador.ast;

import java.util.Map;

public class GreaterEqual implements ASTNode {

	private ASTNode operand1;
	private ASTNode operand2;
	
	
	public GreaterEqual(ASTNode operand1, ASTNode operand2) {
		super();
		this.operand1 = operand1;
		this.operand2 = operand2;
	}
	
	@Override
	public Object execute(Map<String, Object> symbolTable) {		
		return (int)operand1.execute(symbolTable)>=(int)operand2.execute(symbolTable);
	}

}
