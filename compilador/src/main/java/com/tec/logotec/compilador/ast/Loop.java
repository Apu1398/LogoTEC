package com.tec.logotec.compilador.ast;

import java.util.List;
import java.util.Map;

public class Loop implements ASTNode {

	private ASTNode condition;
	private List<ASTNode> body;
	
	
	public Loop(ASTNode condition, List<ASTNode> body) {
		super();
		this.condition = condition;
		this.body = body;
	}


	@Override
	public Object execute(Map<String, Object> symbolTable) {
		while((boolean)condition.execute(null)) {
			for (ASTNode statement : body) {
				statement.execute(symbolTable);
			}
		}
		return null;
	}

}
