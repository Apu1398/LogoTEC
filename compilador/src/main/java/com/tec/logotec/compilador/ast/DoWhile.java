package com.tec.logotec.compilador.ast;

import java.util.List;

public class DoWhile implements ASTNode {


	private ASTNode condition;
	private List<ASTNode> body;
	
	
	public DoWhile(ASTNode condition, List<ASTNode> body) {
		super();
		this.condition = condition;
		this.body = body;
	}
	
	
	@Override
	public Object execute(Context symbolTable) {
		
		do {
			for (ASTNode statement : body) {
				statement.execute(symbolTable);
			}
		}while((boolean)condition.execute(symbolTable));
		return null;
	}
}
