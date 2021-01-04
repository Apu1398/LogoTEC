package com.tec.logotec.compilador.ast;

public class Greater implements ASTNode {

	private ASTNode operand1;
	private ASTNode operand2;
	
	
	public Greater(ASTNode operand1, ASTNode operand2) {
		super();
		this.operand1 = operand1;
		this.operand2 = operand2;
	}

	
	@Override
	public Object execute(Context symbolTable) {
		// TODO Auto-generated method stub
		return (int)operand1.execute(symbolTable)>(int)operand2.execute(symbolTable);
	}

}
