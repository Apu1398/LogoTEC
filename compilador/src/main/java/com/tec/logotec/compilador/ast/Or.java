package com.tec.logotec.compilador.ast;

import java.util.Map;

public class Or implements ASTNode {
	
	private ASTNode operand1;
	private ASTNode operand2;
	
	
	public Or(ASTNode operand1, ASTNode operand2) {
		super();
		this.operand1 = operand1;
		this.operand2 = operand2;
	}

	@Override
	public Object execute(Map<String, Object> symbolTable) {
		// TODO Auto-generated method stub
		return (Boolean)operand1.execute(symbolTable)||(Boolean)operand2.execute(symbolTable);
	}

}
